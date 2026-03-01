using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Zombie : BaseFighter
    {
        public Zombie(int level = 6)
        {
            Level = level;
            Health = Stat(98, 124, 6, 11, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(29, 39, 3, 5, 6);
            PhysicalDefense = Stat(18, 28, 2, 4, 6);
            MagicAttack = Stat(29, 39, 3, 5, 6);
            MagicDefense = Stat(18, 28, 2, 4, 6);
            Speed = Stat(24, 34, 1, 2, 6);
            Abilities = new List<Ability>() { new Rend(), new Blight(), new Devour() };
            CharacterType = "Zombie";
            Mana = Stat(22, 35, 2, 5, 6);
            MaxMana = Mana;
            CritChance = 28;
            CritDamage = 3;
            DodgeChance = 10;
        }

        public Zombie(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Zombie(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(7, 12);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 5);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
