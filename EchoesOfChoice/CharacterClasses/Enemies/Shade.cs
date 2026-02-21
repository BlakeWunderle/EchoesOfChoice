using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Shade : BaseFighter
    {
        public Shade(int level = 4)
        {
            Level = level;
            Health = Stat(74, 89, 5, 10, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(15, 22, 2, 4, 4);
            PhysicalDefense = Stat(10, 16, 1, 3, 4);
            MagicAttack = Stat(17, 24, 2, 5, 4);
            MagicDefense = Stat(13, 19, 2, 4, 4);
            Speed = Stat(21, 29, 2, 5, 4);
            Abilities = new List<Ability>() { new ShadowAttack(), new Frustrate() };
            CharacterType = "Shade";
            Mana = Stat(21, 32, 2, 5, 4);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 2;
        }

        public Shade(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Shade(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 6);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 5);
            PhysicalDefense += random.Next(1, 4);
            MagicAttack += random.Next(2, 6);
            MagicDefense += random.Next(2, 5);
            Speed += random.Next(2, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
