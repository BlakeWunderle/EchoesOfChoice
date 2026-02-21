using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Pixie : BaseFighter
    {
        public Pixie(int level = 4)
        {
            Level = level;
            Health = Stat(40, 59, 3, 7, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(10, 17, 1, 3, 4);
            PhysicalDefense = Stat(7, 11, 1, 2, 4);
            MagicAttack = Stat(8, 15, 1, 3, 4);
            MagicDefense = Stat(8, 15, 1, 3, 4);
            Speed = Stat(27, 39, 3, 6, 4);
            Abilities = new List<Ability>() { new Sting(), new PixieDust() };
            CharacterType = "Pixie";
            Mana = Stat(21, 37, 2, 5, 4);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 1;
            DodgeChance = 4;
        }

        public Pixie(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Pixie(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(3, 7);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
