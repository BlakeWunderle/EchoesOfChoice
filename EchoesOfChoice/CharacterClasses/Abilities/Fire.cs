using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Fire : Ability
    {
        public Fire()
        {
            Name = "Fire";
            FlavorText = "Burn them to a crisp.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
