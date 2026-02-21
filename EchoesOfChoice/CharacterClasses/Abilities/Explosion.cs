using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Explosion : Ability
    {
        public Explosion()
        {
            Name = "Explosion";
            FlavorText = "BOOM!!";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 10;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 6;
        }
    }
}
