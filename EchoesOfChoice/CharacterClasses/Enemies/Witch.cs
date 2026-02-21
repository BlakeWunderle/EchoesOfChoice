using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Witch : BaseFighter
    {
        public Witch(int level = 4)
        {
            Level = level;
            Health = Stat(80, 102, 5, 10, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(7, 11, 1, 2, 4);
            PhysicalDefense = Stat(8, 12, 1, 2, 4);
            MagicAttack = Stat(25, 36, 3, 6, 4);
            MagicDefense = Stat(15, 23, 2, 4, 4);
            Speed = Stat(16, 23, 2, 4, 4);
            Abilities = new List<Ability>() { new Hex(), new Bramble(), new DarkBlessing() };
            CharacterType = "Witch";
            Mana = Stat(29, 45, 3, 6, 4);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Witch(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Witch(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 6);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 2);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
